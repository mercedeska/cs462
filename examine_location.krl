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
        <div id="display">Hello, world!</div>
      >>;
    }
    {
      SquareTag:inject_styling();
      CloudRain:createLoadPanel("Hello World!", {}, my_html);
    }
  }

  rule show_fs_location {
    select when web cloudAppSelected
    pre {
      name = "FILL IN";
      city = "FILL IN";
      time = "FILL IN";
      shout = "FILL IN";
      input_html = << 
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