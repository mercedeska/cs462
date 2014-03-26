ruleset otherPicoApp {
  meta {
    name "Other Pico Foursquare Checkin"
    description <<
      This listens for an event that comes from another pico and
      displays the information on the screen
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
        <h5>Hello, world!</h5>
      >>;
    }
    {
      SquareTag:inject_styling();
      CloudRain:createLoadPanel("Hello World!", {}, my_html);
    }
  }
}