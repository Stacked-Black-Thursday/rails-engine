# Rails Engine API

### Created by: [Genevieve Nuebel](https://github.com/Gvieve)


Rails engine provides foundational API endpoints that can be adopted for a basic e-commerce sales platform. It provides a starting point for a useful database schema, which includes sample records for merchants, items, invoices, customers, and transactions.

#### Built With
* [Ruby on Rails](https://rubyonrails.org)
* [HTML](https://html.com)

This project was tested with:
* RSpec version 3.10

## Contents
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installing](#installing)
- [Endpoints](#endpoints)
  - [All Items](#all-items)
  - [All Merchants](#all-merchants)
  - [Find Item](#find-item)
  - [Find Merchants](#find-merchants)
  - [Merchants by Revenue](#Merchants-by-revenue)
  - [Merchants by Items Sold](#merchants-by-items-sold)
  - [Items by Revenue](#items-by-revenue)
  - [Unshipped Invoices by Potential Revenue](#unshipped-invoices-by-potential-revenue)
- [Testing](#testing)
- [How to Contribute](#how-to-contribute)
- [Roadmap](#roadmap)
- [Contributors](#contributors)
- [Acknowledgments](#acknowledgments)

### Getting Started

These instructions will get you a copy of the project up and running on
your local machine for development and testing purposes. See deployment
for notes on how to deploy the project on a live system.

#### Prerequisites

* __Ruby__

  - The project is built with rubyonrails using __ruby version 2.5.3p105__, you must install ruby on your local machine first. Please visit the [ruby](https://www.ruby-lang.org/en/documentation/installation/) home page to get set up. _Please ensure you install the version of ruby noted above._

* __Rails__
  ```sh
  gem install rails --version 5.2.5
  ```

* __Postgres database__
  - Visit the [postgresapp](https://postgresapp.com/downloads.html) homepage and follow their instructions to download the latest version of Postgres.app.

#### Installing

1. Clone the repo
  ```
  $ git clone https://github.com/Gvieve/rails-engine
  ```

2. Bundle Install
  ```
  $ bundle install
  ```

3. Create, migrate and seed rails database
  ```
  $ rails db:{create,migrate,seed}
  ```

  If you do not wish to use the sample data provided to seed your database, replace the commands in `db/seeds.rb` and the data dump file in `db/data/rails-engine-development.pgdump`.

4. Start rails server
  ```
  $ rails s
  ```

### Endpoints
##### All Items
- Returns a list of items
  - optional query params:
    - page=<integer> (must be 1 or greater) default = 1
    - per_page=<integer> (must be 1 or greater) default = 20
  - examples:
    - http://localhost:3000/api/v1/items (returns items 1 - 20 by default)
    - http://localhost:3000/api/v1/items?page=2&per_page=50 (returns items 51 - 100)

##### All Merchants
- Returns a list of merchants
  - optional query params:
    - page=<integer> (must be 1 or greater) default = 1
    - per_page=<integer> (must be 1 or greater) default = 20
  - examples:
    - http://localhost:3000/api/v1/merchants (returns merchants 1 - 20 by default)
    - http://localhost:3000/api/v1/merchants?page=2&per_page=50 (returns merchants 51 - 100)

##### Find Item
- Returns the first item (sorted alphabetically) that matches the search params.
  - At least on of the following params must be included. Additionally you cannot search by price and name.
    - name=<string>
    - min_price=<float or integer> (must be 0 or greater)
    - max_price=<float or integer> (must be 0 or greater)
  - examples:
    - http://localhost:3000/api/v1/items/find?name=Merchant (returns a single valid result)
    - http://localhost:3000/api/v1/items/find?min_price=25 (returns a single valid result)
    - http://localhost:3000/api/v1/items/find?max_price=25 (returns a single valid result)
    - http://localhost:3000/api/v1/items/find?min_price=25&max_price=30 (returns a single valid result)

##### Find Merchants
- Returns all of the merchants (sorted alphabetically) that match the search params.
  - Required params:
    - name=<'string>
  - examples:
    - http://localhost:3000/api/v1/merchants/find_all?name=merchant (returns all valid results)

##### Merchants by Revenue
- Returns a list of merchants, sorted by total revenue
  - required params:
    - quantity=<intiger> (must be 1 or greater)
  - examples:
    - http://localhost:3000/api/v1/revenue/merchants?quantity=10 (returns first 10 results)

##### Merchants by Items Sold
- Returns a list of merchants, sorted by total items sold
  - required params:
    - quantity=<intiger> (must be 1 or greater)
  - examples:
    - http://localhost:3000/api/v1/merchants/most_items?quantity=8 (returns first 8 results)

##### Items by Revenue
- Returns a list of items, sorted by total items sold
  - Optional params:
    - quantity=<intiger> (must be 1 or greater)
  - examples:
    - http://localhost:3000/api/v1/revenue/items (returns first 10 results by default)
    - http://localhost:3000/api/v1/revenue/items?quantity=8 (returns first 8 results)

##### Unshipped invoices by potential revenue
- Returns a list of invoices that have not been shipped, sorted by total potential revenue
  - Optional params:
    - quantity=<intiger> (must be 1 or greater)
  - examples:
    - http://localhost:3000/api/v1/revenue/unshipped (returns first 10 results by default)
    - http://localhost:3000/api/v1/revenue/unshipped?quantity=8 (returns first 8 results)

### Testing
##### Running Tests
- To run the full test suite run the below in your terminal:
```
$ bundle exec rspec
```
- To run an individual test file run the below in tour terminal:
```
$ bundle exec rspec <file path>
```
for example: `bundle exec rspec spec/requests/merchants_request_spec.rb`

### How to Contribute

In the spirit of collaboration, things done together are better than done on our own. If you have any amazing ideas or contributions on how we can improve this API they are **greatly appreciated**. To contribute:

  1. Fork the Project
  2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
  3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
  4. Push to the Branch (`git push origin feature/AmazingFeature`)
  5. Open a Pull Request

### Roadmap

See the [open issues](https://github.com/Gvieve/rails-engine) for a list of proposed features (and known issues). Please open an issue ticket if you see an existing error or bug.


### Contributors
- [Genevieve Nuebel](https://github.com/Gvieve)

  See also the list of
  [contributors](https://github.com/Gvieve/rails-engine/contributors)
  who participated in this project.

### Acknowledgments
  - My amazing and always supportive 2011 cohort peers at the [Turing School of Software and Design](https://turing.io/):
  - Our fantastically wizard like instructors at [Turing School of Software and Design](https://turing.io/):
    * Ian Douglas
    * Alex Robinson
    * Tim Tyrell
