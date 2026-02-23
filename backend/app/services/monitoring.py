import asyncio
import json
from web3 import Web3
from app.core.config import settings
from fastapi import WebSocket
from typing import List

class BlockchainMonitor:
    def __init__(self):
        self.w3 = Web3(Web3.HTTPProvider(settings.POLYGON_AMOY_RPC_URL))
        self.active_connections: List[WebSocket] = []

    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        self.active_connections.append(websocket)

    def disconnect(self, websocket: WebSocket):
        self.active_connections.remove(websocket)

    async def broadcast(self, message: str):
        for connection in self.active_connections:
            await connection.send_text(message)

    async def start_monitoring(self, contract_address: str, abi: list):
        if not contract_address or contract_address.startswith("0xSimulated"):
            print(f"Contract {contract_address} is simulated. Skipping real-time monitoring.")
            return

        contract = self.w3.eth.contract(address=contract_address, abi=abi)
        # In a real scenario, we would use a WebSocket provider for events
        # For this MVP, we poll for the latest Transfer events
        last_block = self.w3.eth.block_number

        while True:
            try:
                current_block = self.w3.eth.block_number
                if current_block > last_block:
                    events = contract.events.Transfer.get_logs(fromBlock=last_block + 1, toBlock=current_block)
                    for event in events:
                        transfer_data = {
                            "from": event.args['from'],
                            "to": event.args['to'],
                            "value": str(event.args['value']),
                            "transactionHash": event.transactionHash.hex(),
                            "blockNumber": event.blockNumber
                        }
                        await self.broadcast(json.dumps(transfer_data))
                    last_block = current_block
            except Exception as e:
                print(f"Error in blockchain monitoring: {e}")

            await asyncio.sleep(10) # Poll every 10 seconds

monitor = BlockchainMonitor()
