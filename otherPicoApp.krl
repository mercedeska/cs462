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
        <div id="display">Hello, world!</div>
      >>;
    }
    {
      SquareTag:inject_styling();
      CloudRain:createLoadPanel("Hello World!", {}, my_html);
    }
  }

  rule location_catch {
    select when location notification
    pre {
      here = "working!";
      v = event:attr('val');
      l = event:attr('lat');
      totes = event:attrs();
    }
    noop()
    always{
      set ent:val v;
      set ent:h here;
      set ent:lat l;
      set ent:d totes;
    }
  }

  rule location_show {
    select when cloudAppSelected
    pre {
      dec = ent:d.encode();
      input_html = << 
                  <h4>attrs: #{dec}</h4>

                  <h4>lat: #{ent:lat}</h4>
                  >>;
    }
    replace_inner("#display", input_html);
  }
}