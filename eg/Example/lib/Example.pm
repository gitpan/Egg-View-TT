package Example;
use strict;
use warnings;
use Egg qw/ -Debug
  Dispatch::Fast
  Debugging
  Log
  /;

our $VERSION= '0.01';

__PACKAGE__->egg_startup(

  title      => 'Example',
  root       => '/path/to/Example',
  static_uri => '/',
  dir => {
    lib      => '< $e.root >/lib',
    static   => '< $e.root >/htdocs',
    etc      => '< $e.root >/etc',
    cache    => '< $e.root >/cache',
    tmp      => '< $e.root >/tmp',
    template => '< $e.root >/root',
    comp     => '< $e.root >/comp',
    },
  template_path=> ['< $e.dir.template >', '< $e.dir.comp >'],

  VIEW=> [ [ TT => {
    INCLUDE_PATH=> ['< $e.dir.template >', '< $e.root >/comp'],
    TEMPLATE_EXTENSION=> '.tt',
    } ] ],

  );

# Dispatch. ------------------------------------------------
__PACKAGE__->run_modes(
  _default => sub {
    my($d, $e)= @_;
    $e->view->param( server_port => $e->req->port );
    $e->stash( test_title => 'test OK' );
    },
  );
# ----------------------------------------------------------

1;
