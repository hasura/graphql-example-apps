# example-apps

## How to use:

1. Create your heroku app without an access-key
2. Initialize directory for Hasura GraphQL Engine
  ```bash
  hasura init <app-name>
  ```
3. cd into <app-name> and edit config.yaml to update the endpoint
4. Run pg_dump to dump the required schemas
  ```bash
  pg_dump -h host -d database -U user --attribute-inserts -n schema1,schema2 > migrations/1_init.up.sql
  ```
5. Export metadata by running:
  ```bash
  hasura metadata export
  ```
6. Commit all your changes and push to git.
7. Add accounts@hasura.io as collaborator (Important)
  ```bash
  heroku access:add accounts@hasura.io --app <app-name>
  ```

## Buildbot Workflow (this will happen automatically every 30mins):

1. Clone the examples-apps repo
2. Reset postgresql database by running:
  ```bash
  heroku pg:reset --app <app-name> --confirm <app-name>
  ```
3. Restart the app so that graphql-engine is initialized
  ```bash
  heroku restart --app <app-name>
  ```
4. Apply the migrations by running:
  ```bash
  hasura migrate apply
  ```
5. Apply the metadata by running:
  ```bash
  hasura metadata apply
  ```

## Optional files:
  - A README that describes your app
  - A `queries.graphql` file that lists your sample GraphQL queries that GraphiQL will automatically be loaded with
  ```graphql
  # Insert author
  mutation {
    insert_author(objects: [{name: "natwarlal"}] {
      returning {
        id
      }
    }
  }

  # Query author
  query {
    author {
      id
      name
    }
  }
  ```

## What is the point?
- A script will refresh all the databases every 30mins for all the example apps (it will run the migrations in the migrations directory)
- This way you can safely share the Hasura GraphQL engine link with whoever and put it wherever you want, like in your blogpost or on the Hasura website or in a forum or on quora
