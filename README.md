# Highbatch

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/highbatch`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'highbatch'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install highbatch

## Environment Requirements

Ensure that  Ruby `2.5.1` is install on your local vm
I treid to keep dependancies to a minimum, everything contained in this gem is straight ruby.

## Usage

* clone project to local environment
* run `bin/setup` to install dependencies
* run `rake install` to generate gem package and install gem
* run `highbatch <mix tape file path> <changes file path> <output file path>`
*     example: `highbatch '/Users/<user name>/Documents/my_code/highbatch/samples/mixtape.json' '/Users/<user name>/Documents/my_code/highbatch/samples/change_file.json' '/Users/<user name>/Documents/my_code/highbatch/samples/outfile.json'`

sample input files are located in the `samples` directory

## Tests

I am using rspec for automated testing. I have 40 examples, though I probably would typically triple that to get more coverage. I wrote basic tests due to time constraints. 

* run `rspec` to run tests

## TODO

I covered the requirements provided in the task description, though there are many places in the code that are written to extend functionality for `users` and `songs` controllers. This would provide cud operations on these entities. 

One consideration when creating the controllers would be to run through all playlists and remove any playlist that no longer validates. This would be due to either all songs in the playlist were deleted or the associated user was deleted. Either case we would want to remove the playlist as well.

Playlist deleting a song: one thing you will notice is that the playlist change file has an action attribute under the `update` action. This is ignored in the code currently, though my intent was to allow user to add\delete a song in the update.

I do some error handling of attributes in the mixtape.json file. I should probably do more of this in the other models, it would really depend on what the user personae was.

## Change file format
{
  "<controller>": {
    "<action>": [
      {
        <attribute key value pairs>
      }
    ]
  }
}

`example`

{
  "playlists": {
    "new": [
      {
        "user_id": "2",
        "song_ids": [
        "12",
        "30"
        ]
      },
      {
        "user_id": "3",
        "song_ids": [
        "9",
        "10",
        "11",
        "12",
        "13"
        ]
      }
    ],
    "update": [
      {
        "id": "2",
        "action": "add",
        "song_ids": ["10"]
      },
      {
        "id": "5",
        "action": "add",
        "song_ids": ["22"]    -- `allows for multiple songs added at a time`
      }
    ],
    "delete": [
      {
        "id":"2"
      }
    ]
  }
}

## Scope considerations

File size of the mixtape.json is limited to cache size. If the requirement was allow\handle millions of records, I would move from an in cache pseudo data store to a real database (postgres,mysql). I would change the requirement of the file structure to be a PSV (Pipe separated list) allowing me to utilize Postgres data copy utility. I would stream in the file a thousand items at a time and pipe them to the DB. 

The change list I would change to PSV format as well so I would be able to stream that in 1k lines at time. 

The consideration here is that there is a threshold when cached values become resource dependent and performance degrades significantly. This will occur when file size reaches the 10mb plus range or so. 

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
