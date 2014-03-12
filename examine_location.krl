ruleset examine_location {
  meta {
    name "Examine Location"
    description <<
      This prints out the last place
      that was checked into on foursquare

    >>
    author "Mercedes Kurtz"
    logging off
    use module a169x701 alias CloudRain
    use module a41x186  alias SquareTag
    use module b505217x6
  }
  dispatch {
  }
  global {
  }
  rule HelloWorld is active {
    select when web cloudAppSelected
    pre {
      my_html = <<
        <h5>Hello, world!</h5>
      >>;
    }
    {
      SquareTag:inject_styling();
      CloudRain:createLoadPanel("Hello World!", {}, my_html);
    }
  }
}