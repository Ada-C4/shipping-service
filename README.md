This is our shipping API. It's compatible with UPS and USPS shipping services and integrated with the Swagrid checkout system. Destination is set with the building address, but later we would like to refactor for the user to choose the destination address. Currently, package size is set by magic, but in a later refactor we will add dimension and weight attributes to products. 

# Tasks yet to be completed
- 95% test coverage
- Error handling


# Shipping Service API
Build a stand-alone shipping service API that calculates estimated shipping cost for an order from another team's bEtsy application.

## Learning Goals
- Develop the ability to read 3rd party code
- APIs
    - design
    - build
    - test
- Continue working with JSON
- Revisit
    - HTTP interactions
    - Testing of 3rd party services
- Increased confidence in working with 3rd party APIs

## Guidelines
- Practice TDD to lead the development process for Models and Controllers
- Create user stories and keep the stories up-to-date throughout the project
- Deploy on Heroku
- Shipping API will communicate with the bEtsy app via JSON
- Integrate the [ActiveShipping](https://github.com/Shopify/active_shipping) gem to do shipping-specific logic for you

## Project Baseline
When you've accomplished all of the baseline requirements, please issue a PR back to the bEtsy team's fork. We will review and merge your baseline, but you don't need to wait for that to happen before helping your classmates and moving on to the project requirements.

### The baseline requirements are...
- a ruby-gemset and ruby-version.
- a new rails 4.2.5 application.
- [rspec](https://github.com/rspec/rspec-rails) setup in document format (hint: use a .rspec config file and the `rspec_rails` gem)
- [factory_girl](https://github.com/thoughtbot/factory_girl_rails) included and set up to work with rspec
- [simplecov](https://github.com/colszowka/simplecov) for code coverage reporting
- create a NEW fork from the original bEtsy team's fork
  - your team will work on the new fork and issue PRs back to the original team's fork rather than the project master
- create a preliminary Heroku deployment of the bEtsy project
- review bEtsy code to come up with a basic understanding of the current checkout user flow
  - feel free to ask the original bEtsy team questions, but be sure you are prepared to ask them specific questions. Remember, the original developers are on a new team now and are just as busy with new work as you are.

## Expectations
Given shipping addresses and a set of packages, generate a quote for the cost of shipping for these items for a given shipper.

## Requirements
### Technical Requirements
#### Your API will:
- Respond with JSON and proper HTTP response codes  
- Allow Users to get shipping cost quotes for different delivery types (standard, express, overnight, etc.)
- Allow Users to get a cost comparison of two or more carriers  
- Have appropriate error handling:
  - When a User's request is incomplete, return an appropriate error
  - When a User's request does not process in a timely manner, return an appropriate error

#### Your bEtsy application will:
- Integrate packaging estimates into the checkout workflow to be able to utilize the shipping API
- Present the relevant shipping information to the user during the checkout process
  - Cost
  - Delivery estimate

### Testing
- 95% test coverage for all API Controller routes, Model validations, and Model methods

### Added Fun!
- Log all requests and their associated responses such that an audit could be conducted  
- Do some refactoring of the bEtsy project you're working on
- Allow merchants to view the total shipping costs for all of their products in a particular order
- Find the seam in bEtsy app between the shopping and payment processing, and build a payment processing service
