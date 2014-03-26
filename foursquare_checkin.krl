ruleset FourSquare_checkin {
  meta {
    name "FourSquare Checkins"
    description <<
      This ruleset waits for a push from Foursquare. When it receives it,
      the user's checkin information is displayed
    >>
    author "Mercedes Kurtz"
    logging off
    use module a169x701 alias CloudRain
    use module a41x186  alias SquareTag
  }
  dispatch {
  }
  global {
    accessToken = "KF5GBIACBGZQDRDPCHIUPF3K4XBB0PGET02KYQKMX5EGIU0L";

    //subscription_map = [ {"name": "test1",
    //                      "cid": "48A2CD0C-B483-11E3-8919-F118ABD0D405"
      //                   },
        //                 {"name": "test2",
          //                "cid": "BD5B7C66-B483-11E3-A317-856AAD931101"
            //             }];
    subscription_map = {"name": "test1",
                        "esl": "https://cs.kobj.net/sky/event/48A2CD0C-B483-11E3-8919-F118ABD0D405/92/location/notification?_rids=b505850x0"
                       };
  }
  rule Foursquare is active {
    select when web cloudAppSelected
    pre {
      my_html = <<
        <h5>Last Checkin:</h5>
        <div id="repl"> lalalala get rid of</div>
      >>;
    }
    {
      SquareTag:inject_styling();
      CloudRain:createLoadPanel("Foursquare Checkin", {}, my_html);
    }
  }

  rule process_fs_checkin {
    select when foursquare checkin
    pre {
      json_file = event:attr("checkin");
      content = json_file.decode();
      ven = content.pick("$.venue");
      nm = ven.pick("$.name").as('str');
      cty = ven.pick("$.location.city").as('str');
      lt = ven.pick("$.location.lat");
      ln = ven.pick("$.location.lng");
      sh = content.pick("$.shout").as('str');
      created = content.pick("$.createdAt");
      k = 'fs_checkin';
      v = {'venue' : nm, 'city' : cty, 'shout' : sh, 'created' : created, 'lat' : lt, 'lng': ln};
    }
    send_directive(nm) with key = 'checkin' and value = nm;
    always {
      set ent:json_fl json_file;
      set ent:name nm;
      set ent:city cty;
      set ent:shout sh;
      set ent:createdAt created;
      set ent:lat lt;
      set ent:lng ln;
      set ent:key k;
      set ent:val v;
      raise pds event 'new_location_data' for 'b505217x6' with key = k and value = v;
    }
  }

  rule display_checkin {
    select when cloudAppSelected
    pre {
      check_time = function(time) {
        curr_time = time:now();
        neg_at = -1 * ent:createdAt;
        diff = time:add(curr_time, {"seconds": neg_at});
        neg_diff = time:strftime(diff, "%s") * -1;
        ret = time:add(curr_time, {"seconds": neg_diff});
        ret
      };
      jf = ent:json_fl;
      dec = jf.encode();
      out_time = check_time(ent:createdAt);
      print_time = time:strftime(out_time, "%c");

      input_html = << 
                  <h7> decode: #{dec}</h7>
                  <table style="border-spaceing:3px;width=22em;font-size:87%;;">
                    <tbody>
                      <tr>
                        <th scope="row" style="text-align:left;white-space: nowrap;;">Name</th>
                        <td>#{ent:name}</td>
                      </tr>
                      <tr>
                        <th scope="row" style="text-align:left;white-space: nowrap;;">City</th>
                        <td>#{ent:city}</td>
                      </tr>
                      <tr>
                        <th scope="row" style="text-align:left;white-space: nowrap;;">Created At</th>
                        <td>#{print_time}</td>
                      </tr>
                      <tr>
                        <th scope="row" style="text-align:left;white-space: nowrap;;">Latitude</th>
                        <td>#{ent:lat}</td>
                      </tr>
                      <tr>
                        <th scope="row" style="text-align:left;white-space: nowrap;;">Longitude</th>
                        <td>#{ent:lng}</td>
                      </tr>
                      <tr>
                        <th scope="row" style="text-align:left;white-space: nowrap;;">Shout</th>
                        <td>#{ent:shout}</td>
                      </tr>
                    </tbody>
                  </table> 
                  <div id="w">hey: #{ent:test_dispatch}</div> >>;
    }
    replace_inner("#repl", input_html);
  }

  rule the_dispatch {
    select when cloudAppSelected
      //foreach subscription_map setting (s)
        event:send(subscription_map,"location","notification") 
          with attrs = {"key": ent:key,
                        "val": ent:val}
        always {
          set ent:test_dispatch "sent dispatch"
        }
  }

}

//https://cs.kobj.net/sky/event/8D87DEF2-A30E-11E3-8588-DF7CD61CF0AC/33/foursquare/checkin?_rids=b505217x4

// Lab details from Ryan - 
// you'll have to manually allow your progam to have access to your person
// notify doesn't work for this, set entity variables
// you'll have to refresh the page after every checkin to see the updated variables
// domain - foursquare
// type - checkin
