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
      here = "boom sha ka la ka!";
      v = event:attr('val');
      l = event:attr('lat');
    }
    noop()
    always{
      set ent:val v;
      set ent:h here;
      set ent:lat l;
    }
  }

  rule location_show {
    select when cloudAppSelected
    pre {
      deets = ent:val.decode();
      valueType = deets.typeof();
      name = deets.pick("$..venue").as('str');
      city = deets.pick("$.city");
      time = deets.pick("$.created").as('str');
      shout = deets.pick("$.shout").as("str");
      input_html = << 
                  <h1>working? #{ent:h} #{ent:lat}</h1>
                  <h2>type: #{valueType}</h2>
                  <h3>deets: #{deets}</h3>
                  <table style="border-spaceing:3px;width=22em;font-size:87%;;">
                    <tbody>
                      <tr>
                        <th scope="row" style="text-align:left;white-space: nowrap;;">Name:</th>
                        <td>#{name}</td>
                      </tr>
                      <tr>
                        <th scope="row" style="text-align:left;white-space: nowrap;;">City:</th>
                        <td>#{city}</td>
                      </tr>
                      <tr>
                        <th scope="row" style="text-align:left;white-space: nowrap;;">Created At:</th>
                        <td>#{time}</td>
                      </tr>
                      <tr>
                        <th scope="row" style="text-align:left;white-space: nowrap;;">Shout:</th>
                        <td>#{shout}</td>
                      </tr>
                    </tbody>
                  </table> >>;
    }
    replace_inner("#display", input_html);
  }
}