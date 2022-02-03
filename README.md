## fastapi-postgres-base

Clone this repo
```bash
git clone https://github.com/hoangthanhtien/fastapi-postgres-base.git
```

Create env and install dependencies

```bash
# Create env
cd fastapi-postgres-base
python3 -m venv venv
# Active env
source venv/bin/activate
# Install dependencies
pip install -r requirements.txt
```
Install & run Postgresql with dockercompose

```bash
docker-compose up -d
```

Migrate all models to database

```
# Add run permission to migration script if needed 
chmod u+x ./migrate_database.sh
./migrate_database.sh
```

Run server

```bash
# Add run permission to run file if needed 
chmod u+x ./run.sh
./run.sh
```
