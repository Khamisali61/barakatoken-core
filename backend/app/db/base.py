# Import all the models, so that Base has them before being
# imported by Alembic or used by metadata
from app.db.session import Base  # noqa
from app.models.user import User  # noqa
from app.models.sukuk import SukukAsset  # noqa
from app.models.mpesa import MpesaTransaction  # noqa
from app.models.compliance import ComplianceLog  # noqa
from app.models.distribution import Distribution  # noqa
