from fastapi.params import Depends
from fastapi_crudrouter import SQLAlchemyCRUDRouter
from models.potato import * 
from config.database import get_db 
from middlewares.potato import example_middleware 

router = SQLAlchemyCRUDRouter(
    schema=Potato,
    create_schema=PotatoCreate,
    db_model=PotatoModel,
    db=get_db,
    prefix='potato',
    dependencies = [Depends(example_middleware)]
)
