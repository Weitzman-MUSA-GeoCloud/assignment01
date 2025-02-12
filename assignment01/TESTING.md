# Linting & Testing

## Linting with SQLFluff

The project is linted with **[SQLFluff](https://sqlfluff.com/)**. A linter is a developer tool that will read and analyze your code for common programming errors and stylistic issues. _Linter errors may not imply that your code doesn't work, but they're still important to resolve!_

To run the linter, first install **[SQLFluff](https://sqlfluff.com/)**, then run the following in the assignment01 folder:

```
sqlfluff lint
```

There are some stylistic issues that **SQLFluff** can resolve automatically. To address these issues, run:

```
sqlfluff fix
```

Any remaining violations will be listed.

## Testing with Jest

The project has automated tests written using a **[node.js](https://nodejs.org/)** package called **[Jest](https://jestjs.io/)**. The test scripts live in the [__tests__/](__tests__/) folder.

First install **[node.js](https://nodejs.org/)**, and then use the Node Package Manager (`npm`) to install the project dependencies (which are listed in [package.json](package.json)) such as Jest:

```
npm install
```

Then, configure how the tests will access your database. Assuming you have a database with tables created as specified at the top of this README, copy the [.env.template](.env.template) file and create a new file named ".env" in the same folder. Note that the first dot (".") in the file name is intentional. You can copy the file on the command line with the `cp` command:

```
cp .env.template .env
```

Open the .env file and update the variable values to match the connection parameters for your database.

Finally, to run all the tests, run:

```
npm test
```

If you want to run the test for a specific query, e.g. query 06, use the following syntax, replacing the number (`06`) as appropriate:

```
npm test __tests__/test_query06.js
```