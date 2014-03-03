ruleset FourSquare_checkin {
  meta {
    name "FourSquare Checkin"
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
  }
  rule Foursquare is active {
    select when web cloudAppSelected
    pre {
      my_html = <<
        <h5>Hello, world!</h5
        <div id=token> The access token: #{accessToken} </div>
      >>;
    }
    {
      SquareTag:inject_styling();
      CloudRain:createLoadPanel("Foursquare Checkins for Mercedes", {}, my_html);
    }
  }
}


// Lab details from Ryan - 
// you'll have to manually allow your progam to have access to your person
// notify doesn't work for this, set entity variables
// you'll have to refresh the page after every checkin to see the updated variables
// domain - foursquare
// type - checkin
