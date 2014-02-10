
ruleset NameOrMonkey {
    meta {
        name "Lab 2 cs462"
        author "Mercedes Kurtz"
        logging off
    }
    dispatch {
        // domain "exampley.com"
    }
    rule first_task {
        select when pageview ".*" 
        // Display notification that will not fade.
        pre {}
        {
            notify("Hello World", "This is a sample rule.");
            notify("The second box", "I wanted to put 2 on...");
        }
    }

    rule second_task {
        select when pageview ".*"
        pre {}
        {
            notify ("hello 3", "whatever");
        }
    }
}