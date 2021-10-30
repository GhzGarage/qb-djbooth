Config = {}

Config.DefaultVolume = 0.1 -- Accepted values are 0.01 - 1

Config.Locations = {
    ['vanilla'] = {
        ['job'] = 'unicorn', -- Required job to use booth
        ['radius'] = 50, -- The radius of the sound from the booth
        ['coords'] = vector3() -- Where the booth is located
    },
    ['other'] = {
        ['job'] = 'other',
        ['radius'] = 50,
        ['coords'] = vector3()
    }
}