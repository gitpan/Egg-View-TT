
use Test::More tests => 15;
use Egg::Helper::VirtualTest;

my $test= Egg::Helper::VirtualTest->new;
   $test->prepare(
     config=> { VIEW=> [ [
       TT => {
         INCLUDE_PATH=> ['< $e.dir.template >'],
         TEMPLATE_EXTENSION=> '.tt',
         },
       ] ] },
     create_files => $test->yaml_load( join '', <DATA> ),
     );

my $e= $test->egg_pcomp_context;

ok my $view= $e->view('TT');
isa_ok $view, 'Egg::View::TT';
can_ok $view, qw/ new output render reset _setup /;
ok my $conf= $view->config;
isa_ok $conf, 'HASH';
ok $e->page_title('TEST PAGE');
ok $e->stash( test_title => 'VIEW TEST' );
ok $view->param( server_port => $e->request->port );
ok $body= $view->output('index.tt');
isa_ok $body, 'SCALAR';
like $$body, qr{<html>.+?</html>}s;
like $$body, qr{<title>TEST PAGE</title>}s;
like $$body, qr{<h1>VIEW TEST</h1>}s;
like $$body, qr{<div>TEST OK</div>}s;
like $$body, qr{<p>80</p>}s;

__DATA__
---
filename: root/index.tt
value: |
  <html>
  <head>
  <title>[% e.page_title %]</title>
  </head>
  <body>
  <h1>[% s.test_title %]</h1>
  <div>TEST OK</div>
  <p>[% p.server_port %]</p>
  </body>
  </html>
