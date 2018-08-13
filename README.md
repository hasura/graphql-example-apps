# example-apps

## How to use:

1. Create your heroku app without an access-key
2. Create a folder that contains:
  - a hasura migrations directory that should have a data migration to import sample data too
  - A example-app.yaml file that contains the following:
  ```yaml
  herokuapp: https://myapp.herokuapp.com
  database_url: YOUR_SECRET_DATABASE_URL
  ```
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
- A script will refresh all the databases every 30mins for all the example apps
- This way you can safely share the Hasura GraphQL engine link with whoever and put it wherever you want

## Security
Yes, this is totally insecure, but till we have a better way of storing DATABASE_URL configurations that can be 
picked up by our script dynamically, deal with it.

This repo is private for a reason.
