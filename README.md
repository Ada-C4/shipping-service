## Welcome to Shipple
We make shipping easy! We take your data and return basic shipping information from USPS or UPS including: estimated delivery date (for UPS) and cost of shipping for various shipping options.

To interact with the API, please make a post request with JSON in the following format in the body.

  ```ruby
  { packages: [{ dimensions: [25, 10, 15], weight: 500 }, { dimensions: [18, 30, 10], weight: 5000 }], origin: { state: "WA", city: "Seattle", zip: "98101" }, destination: { state: "IL", city: "Vernon Hills", zip: "60061" } }.to_json```

# Example HTTParty requests to our service!


  HTTParty.post("http://shipple.herokuapp.com/ups/", headers: { 'Content-Type' => 'application/json' }, body: params)
  HTTParty.post("http://shipple.herokuapp.com/usps/", headers: { 'Content-Type' => 'application/json' }, body: params)
