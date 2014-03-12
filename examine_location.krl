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
    use module b505217x6 alias location_data
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
      CloudRain:createLoadPanel("Last Foursquare checkin", {}, my_html);
    }
  }

  rule show_fs_location {
    select when web cloudAppSelected
    pre {
      deets = location_data:get_location_data('fs_checkin').decode();
      name = deets.pick("$.venue").as('str');
      city = deets.pick("$.city").as("str");
      time = deets.pick("$.created").as('str');
      shout = deets.pick("$.shout").as("str");
      input_html = << 
                  <h3>deets: #{deets}</h3>
                  <table style="border-spaceing:3px;width=22em;font-size:87%;;">
                    <tbody>
                      <tr>
                        <th scope="row" style="text-align:left;white-space: nowrap;;">Name</th>
                        <td>#{name}</td>
                      </tr>
                      <tr>
                        <th scope="row" style="text-align:left;white-space: nowrap;;">City</th>
                        <td>#{city}</td>
                      </tr>
                      <tr>
                        <th scope="row" style="text-align:left;white-space: nowrap;;">Created At</th>
                        <td>#{time}</td>
                      </tr>
                      <tr>
                        <th scope="row" style="text-align:left;white-space: nowrap;;">Shout</th>
                        <td>#{shout}</td>
                      </tr>
                    </tbody>
                  </table> >>;
    }
    replace_inner("#display", input_html);
  }
}