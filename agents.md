# BarakaToken Production Agent (Jules) Instructions

## 1. Project Vision & Identity
- **Name:** BarakaToken
- **Mission:** A standalone, Shariah-compliant tokenized Sukuk platform for the Kenyan retail market.
- **Brand Identity:** High-end, dark-emerald aesthetic (#008F58 / #000000) inspired by the UI screenshots in `/design`. Use KES as the primary currency.

## 2. Technical Stack & Architecture
- **Backend:** Python 3.11+ (FastAPI) for high performance and asynchronous task handling.
- **Database:** PostgreSQL (Primary Standalone Ledger). Use SQLAlchemy or Tortoise ORM for strictly typed operations.
- **Blockchain:** Solidity smart contracts deployed on Polygon PoS (L2) for near-zero gas fees. Use Hardhat for the development environment.
- **Mobile:** Flutter (Dart) targeting iOS and Android, focusing on the "mobile-first" Kenyan demographic.
- **Payments:** Direct integration with Safaricom Daraja API (M-Pesa G2) for STK Push and C2B/B2C transactions.

## 3. Shariah & Financial Compliance Rules (Non-Negotiable)
- **Zero-Interest Policy:** All returns must be calculated as "Profit Shares" from underlying assets. Absolutely no interest (Riba) logic.
- **Asset Backing:** Every minted token must correlate 1:1 with an entry in the `physical_assets` table. Tokens cannot be minted without a verified asset legal document URL.
- **Purification Logic:** Implement a `PurificationManager` service to flag income from non-permissible sources for charity disbursement.
- **Numerical Precision:** Use the `Decimal` type for all financial calculations. Never use floats. Maintain 4 decimal places of precision.

## 4. Production Security & Quality Standards
- **Payment Idempotency:** Every M-Pesa callback must check the `MerchantRequestID` against existing records to prevent double-crediting wallets.
- **Account Abstraction (ERC-4337):** Hide blockchain complexity. Users should pay transaction fees in KES, not MATIC/ETH.
- **Logging & Auditing:** Every state change (Minting, Investing, Payout) must generate an immutable audit log entry in the `compliance_logs` table.
- **Testing:** Maintain >90% test coverage using `pytest` for backend and `flutter_test` for mobile.

## 5. UI/UX Directives
- **Source of Truth:** All screen layouts must match the HTML/CSS and 19 images in the `/design` folder.
- **Local Context:** Prominently display the 'CMA Regulatory Sandbox' status and 'Certified Shariah Board' seals on the dashboard.
