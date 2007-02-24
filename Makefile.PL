use inc::Module::Install;
name 'Egg-View-TT';
author 'Masatoshi Mizuno E<lt>mizunoE<64>bomcity.comE<gt>';
all_from 'lib/Egg/View/TT.pm';
version_from 'lib/Egg/View/TT.pm';
license      'perl';

requires 'Egg::Release' => '1.09';
requires 'Template';

requires 'Test::Pod';
requires 'Test::More';

use_test_base;
auto_install;
WriteAll;
