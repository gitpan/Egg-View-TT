use inc::Module::Install;

name         'Egg-View-TT';
all_from     'lib/Egg/View/TT.pm';
version_from 'lib/Egg/View/TT.pm';
author       'Masatoshi Mizuno E<lt>lusheE<64>cpan.orgE<gt>';
license      'perl';

requires 'Egg::Release' => '1.09';
requires 'Template';

requires 'Test::Pod';
requires 'Test::More';

use_test_base;
auto_install;
WriteAll;
