from web3 import Web3
from app.core.config import settings
import json
import os

class BlockchainService:
    def __init__(self):
        self.w3 = Web3(Web3.HTTPProvider(settings.POLYGON_AMOY_RPC_URL))
        self.admin_private_key = settings.ADMIN_PRIVATE_KEY
        self.admin_address = self.w3.eth.account.from_key(self.admin_private_key).address if self.admin_private_key and self.admin_private_key != "0xabc123..." else None

    def mint_tokens(self, asset_title: str, total_valuation: float, legal_doc_url: str):
        if not self.admin_address:
            print("Admin private key not configured. Skipping real blockchain transaction.")
            return "0xSimulatedContractAddress"

        # In a real scenario, we would deploy a new SukukToken contract or mint in an existing one
        # For this slice, let's assume we deploy a new SukukToken for each asset

        # Load contract data (ABI and Bytecode)
        # Note: In production, these should be pre-compiled and stored
        contract_path = os.path.join(os.path.dirname(__file__), "../../../../blockchain/artifacts/contracts/SukukToken.sol/SukukToken.json")
        if not os.path.exists(contract_path):
             print(f"Contract artifacts not found at {contract_path}. Skipping.")
             return "0xArtifactsNotFound"

        with open(contract_path) as f:
            contract_json = json.load(f)
            abi = contract_json['abi']
            bytecode = contract_json['bytecode']

        SukukToken = self.w3.eth.contract(abi=abi, bytecode=bytecode)

        # Build transaction
        transaction = SukukToken.constructor(
            asset_title,
            "SKK", # Symbol
            int(total_valuation),
            legal_doc_url
        ).build_transaction({
            'from': self.admin_address,
            'nonce': self.w3.eth.get_transaction_count(self.admin_address),
            'gas': 2000000,
            'gasPrice': self.w3.to_wei('30', 'gwei')
        })

        # Sign and send
        signed_txn = self.w3.eth.account.sign_transaction(transaction, private_key=self.admin_private_key)
        tx_hash = self.w3.eth.send_raw_transaction(signed_txn.rawTransaction)
        tx_receipt = self.w3.eth.wait_for_transaction_receipt(tx_hash)

        return tx_receipt.contractAddress

blockchain_service = BlockchainService()
