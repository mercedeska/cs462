ruleset location_data {
  meta {
    name "Location Data"
    description <<
      Stores keys and values for the locations of foursquare checkins
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

  rule add_location_item {
    select when pds new_location_data
    pre {
      the_map = ent:my_map;
      key = event:attr('key');
      value = event:attr('value');
      ret_map = the_map.put(key,value);
    }
    noop()
    always {
      set ent:my_map ret_map
    }
  }
}