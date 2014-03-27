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
    pre{
      here = "in here!";
      la = event:attr('lat');
      lo = event:attr('lng');
    }
    noop()
    always{
      set ent:lat la;
      set ent:lng lo;
      set ent:h here;
    }
  }

  rule location_show {
    select when cloudAppSelected
    pre {
      input_html = << 
                  <h1>working? #{ent:h}</h1>
                  <table style="border-spaceing:3px;width=22em;font-size:87%;;">
                    <tbody>
                      <tr>
                        <th scope="row" style="text-align:left;white-space: nowrap;;">Latitude:</th>
                        <td>#{ent:lat}</td>
                      </tr>
                      <tr>
                        <th scope="row" style="text-align:left;white-space: nowrap;;">Longtitue:</th>
                        <td>#{ent:lng}</td>
                      </tr>
                    </tbody>
                  </table> >>;
    }
    replace_inner("#display", input_html);
  }
}