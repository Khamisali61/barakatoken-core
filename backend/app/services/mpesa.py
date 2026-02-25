import base64
from datetime import datetime
import requests
from app.core.config import settings
from app.models.mpesa import MpesaTransaction
from sqlalchemy.orm import Session

class MpesaService:
    def __init__(self):
        self.consumer_key = settings.MPESA_CONSUMER_KEY
        self.consumer_secret = settings.MPESA_CONSUMER_SECRET
        self.shortcode = settings.MPESA_SHORTCODE
        self.passkey = settings.MPESA_PASSKEY
        self.callback_url = settings.MPESA_CALLBACK_URL
        self.base_url = "https://sandbox.safaricom.co.ke"

    def get_access_token(self):
        url = f"{self.base_url}/oauth/v1/generate?grant_type=client_credentials"
        response = requests.get(url, auth=(self.consumer_key, self.consumer_secret))
        return response.json().get("access_token")

    def initiate_stk_push(self, db: Session, user_id: int, amount: float, phone_number: str):
        access_token = self.get_access_token()
        timestamp = datetime.now().strftime("%Y%m%d%H%M%S")
        password = base64.b64encode(f"{self.shortcode}{self.passkey}{timestamp}".encode()).decode()

        headers = {"Authorization": f"Bearer {access_token}"}
        payload = {
            "BusinessShortCode": self.shortcode,
            "Password": password,
            "Timestamp": timestamp,
            "TransactionType": "CustomerPayBillOnline",
            "Amount": int(amount),
            "PartyA": phone_number,
            "PartyB": self.shortcode,
            "PhoneNumber": phone_number,
            "CallBackURL": self.callback_url,
            "AccountReference": "BarakaToken",
            "TransactionDesc": "Sukuk Investment"
        }

        url = f"{self.base_url}/mpesa/stkpush/v1/processrequest"
        response = requests.post(url, json=payload, headers=headers)
        res_data = response.json()

        if res_data.get("ResponseCode") == "0":
            # Record pending transaction
            transaction = MpesaTransaction(
                user_id=user_id,
                merchant_request_id=res_data["MerchantRequestID"],
                checkout_request_id=res_data["CheckoutRequestID"],
                amount=amount,
                phone_number=phone_number,
                status="Pending"
            )
            db.add(transaction)
            db.commit()
            return res_data
        else:
            return res_data

    def handle_callback(self, db: Session, callback_data: dict):
        # Extract data
        stk_callback = callback_data.get("Body", {}).get("stkCallback", {})
        merchant_request_id = stk_callback.get("MerchantRequestID")
        result_code = stk_callback.get("ResultCode")
        result_desc = stk_callback.get("ResultDesc")

        # Find transaction
        transaction = db.query(MpesaTransaction).filter(
            MpesaTransaction.merchant_request_id == merchant_request_id
        ).first()

        if not transaction:
            return {"status": "error", "message": "Transaction not found"}

        if transaction.status != "Pending":
            return {"status": "success", "message": "Already processed"} # Idempotency

        if result_code == 0:
            # Success
            transaction.status = "Success"
            callback_metadata = stk_callback.get("CallbackMetadata", {}).get("Item", [])
            for item in callback_metadata:
                if item.get("Name") == "MpesaReceiptNumber":
                    transaction.mpesa_receipt_number = item.get("Value")

            # Update User Balance
            from app.models.user import User
            user = db.query(User).filter(User.id == transaction.user_id).first()
            if user:
                user.kes_balance += transaction.amount

            # TODO: Trigger token minting logic here if it was an investment
        else:
            transaction.status = "Failed"

        transaction.result_code = result_code
        transaction.result_desc = result_desc

        db.commit()
        return {"status": "success"}

    def mock_topup(self, db: Session, user_id: int, amount: float):
        from app.models.user import User
        import uuid

        user = db.query(User).filter(User.id == user_id).first()
        if not user:
            return {"status": "error", "message": "User not found"}

        # Record mock transaction
        transaction = MpesaTransaction(
            user_id=user_id,
            merchant_request_id=f"MOCK-{uuid.uuid4()}",
            checkout_request_id=f"MOCK-{uuid.uuid4()}",
            amount=amount,
            phone_number=user.phone_number or "MOCK",
            status="Success",
            mpesa_receipt_number=f"MOCK{uuid.uuid4().hex[:6].upper()}",
            result_code=0,
            result_desc="Mock Success"
        )
        db.add(transaction)

        # Update Balance
        user.kes_balance += amount

        db.commit()
        return {"status": "success", "new_balance": float(user.kes_balance)}

mpesa_service = MpesaService()
