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

  rule nearby {
    select when location new_currant
    pre {
      la = event:attr('lat');
      lo = event:attr('long');

      r90   = math:pi()/2;      
      rEk   = 6378;         // radius of the Earth in km       
      // point a
      lata  = 40.4267290; //change this to la
      lnga  = -111.9025358; //change this to lo       
      // point b
      latb  = 43.8310154; // change this to current location latitude
      lngb  = -111.7747790; //change this to current location longitude       
      // convert co-ordinates to radians
      rlata = math:deg2rad(lata);
      rlnga = math:deg2rad(lnga);
      rlatb = math:deg2rad(latb);
      rlngb = math:deg2rad(lngb);       
      // distance between two co-ordinates in radians
      dR = math:great_circle_distance(rlnga,r90 - rlata, rlngb,r90 - rlatb);       
      // distance between two co-ordinates in kilometers
      dE = math:great_circle_distance(rlnga,r90 - rlata, rlngb,r90 - rlatb, rEk);
      //8 kilometers is about 5 miles (a little less)
      threshold = 8 
    }
    if (threshold > dE) then noop();
    fired {
      set ent:inhere "lalala";
      raise explicit event 'location_nearby' with distance = dE
    } else {
      set ent:inhere "lalala";
      raise explicit event 'location_far' with distance = deg2rad
    }
  }

  rule display_working {
    select when cloudAppSelected
    pre {
      out  = <<
       holla! #{ent:inhere}
      >>;
    }    
    replace_inner("#repl", input_html);
  }
}