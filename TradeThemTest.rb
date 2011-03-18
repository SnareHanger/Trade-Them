#Unit test for TradeThem
require 'TradeThem'
require 'mocha'

Twitter.stubs(:configure)

TWITTERCOMM.any_instance.expects(:getMentions).returns(array1)
TradeThem.main()
#at this point, database should be in a certain state

TWITTERCOMM.any_instance.expects(:getMentions).returns(array2)
TradeThem.main()
#at this point, database should be in a certain state

TWITTERCOMM.any_instance.expects(:getMentions).returns(array3)
TradeThem.main()
#at this point, database should be in a certain state
