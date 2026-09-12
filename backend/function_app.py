import json
import logging
import os

import azure.functions as func
from azure.cosmos import CosmosClient, exceptions

app = func.FunctionApp(http_auth_level=func.AuthLevel.ANONYMOUS)


@app.route(route="GetVisitorCount")
def GetVisitorCount(req: func.HttpRequest) -> func.HttpResponse:
    try:
        logging.info("Python HTTP trigger function processed a request.")

        db_url: str | None = os.environ.get("COSMOS_DB_URL")

        db_key: str | None = os.environ.get("COSMOS_DB_KEY")

        if not db_url or not db_key:
            raise ValueError("COSMOS_DB_URL and COSMOS_DB_KEY must be set.")

        # Create an instance of the CosmosClient using the URL and key
        client = CosmosClient(db_url, credential=db_key)

        # Get the database
        database_name = client.get_database_client("db-crc-dev-ctus")

        # Get the container
        container_name = database_name.get_container_client("visitors")

        item = container_name.read_item(item="1", partition_key="1")

        item["visitors"] = item.get("visitors", 0) + 1

        container_name.replace_item(item=item["id"], body=item)

        print(item)
        return func.HttpResponse(
            body=json.dumps({"visitors": item["visitors"]}),
            status_code=200,
            mimetype="application/json",
        )
    except exceptions.CosmosResourceNotFoundError:
        item = {"id": "1", "visitors": 1}
        container_name.create_item(body=item)  # type: ignore
        return func.HttpResponse(f"Visitor count: {item}", status_code=200)
    except Exception as e:
        logging.error(f"An error occurred: {e}")
        return func.HttpResponse(
            "An error occurred while processing the request.",
            status_code=500,
        )
