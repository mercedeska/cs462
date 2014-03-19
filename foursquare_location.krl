ruleset foursquare_location {
  meta {
    name "foursquare_location"
    description <<
      Is activiated when a new checkin with latitude and longitude is called
    >>
    author "Mercedes Kurtz"
    logging off
    use module a169x701 alias CloudRain
    use module a41x186  alias SquareTag
  }
  dispatch {
  }
  global {
  }
  rule HelloWorld is active {
    select when web cloudAppSelected
    pre {
      my_html = <<
        <h5>Seeing if this is being called!</h5>
      >>;
    }
    {
      SquareTag:inject_styling();
      CloudRain:createLoadPanel("Foursquare Location!", {}, my_html);
    }
  }
}