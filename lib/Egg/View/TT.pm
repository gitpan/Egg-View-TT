package Egg::View::TT;
#
# Masatoshi Mizuno E<lt>lusheE<64>cpan.orgE<gt>
#
# $Id: TT.pm 97 2007-05-07 23:58:00Z lushe $
#

=head1 NAME

Egg::View::TT - Template ToolKit for Egg View.

=head1 SYNOPSIS

  __PACKAGE__->egg_startup(
    ...
    .....
  
  VIEW=> [
    [ TT => {
       INCLUDE_PATH=> [qw( /path/to/root /path/to/comp )],
       TEMPLATE_EXTENSION=> '.tt',
       ... other Template ToolKit option.
       } ],
    ],
  
   );

  # The VIEW object is acquired.
  my $view= $e->view('TT');
  
  # It outputs it specifying the template.
  my $content= $view->render('hoge.tt', \%option);

=head1 DESCRIPTION

It is VIEW to use Template ToolKit.

Please add the setting of VIEW to the project to use it.

  VIEW => [
    [ TT => { ... Template ToolKit option. (HASH) } ],
    ],

* Please refer to the document of L<Template> for the option.

It accesses the object and data by using following variable from the template.

  e ... Object of project.
  s ... $e->stash.
  p ... $e->view('Mason')->params.

=cut
use strict;
use warnings;
use Carp qw/croak/;
use base qw/Egg::View/;
use Template;

our $VERSION = '2.00';

=head1 METHODS

=head2 new

When $e-E<gt>view('TT') is called, this constructor is called.

Please set %Egg::View::PARAMS directly from the controller to the parameter
that wants to be set globally.

  %Egg::View::PARAMS= %NewPARAM;

=head2 params, param

The parameter that wants to be passed to Template ToolKit must use these methods.

=cut

sub _setup {
	my($class, $e, $conf)= @_;
	$conf->{ABSOLUTE}= 1 unless exists($conf->{ABSOLUTE});
	$conf->{RELATIVE}= 1 unless exists($conf->{RELATIVE});
}

=head2 render ( [TEMPLATE], [OPTION] )

TEMPLATE is evaluated and the output result (SCALAR reference) is returned.

It is given priority more than set of default when OPTION is passed.

  my $body= $view->render( 'foo.tt', [OPTION_HASH] );

=cut
sub render {
	my $view= shift;
	my $tmpl= shift || return(undef);
	$view->{TemplateToolkit} ||= do {
		my %options= @_ ? ($_[1] ? @_: %{$_[0]}): ();
		while (my($key, $value)= each %{$view->config}) {
			$options{$key}= $value if defined($value);
		}
		($options{TIMER} && ! $options{CONTEXT}) and do {
			require Template::Timer;
			$options{CONTEXT}= Template::Timer->new(%options);
		  };
		Template->new(\%options) || Egg::Error->throw( Template->error );
	  };
	my $body;
	my %var = (
	  e => $view->{e},
	  s => $view->{e}->stash,
	  p => $view->params,
	  );
	$view->{TemplateToolkit}->process($tmpl, \%var, \$body)
	       || die $view->{TemplateToolkit}->error;
	\$body;
}

=head2 output ( [TEMPLATE], [OPTION] )

The output result of the receipt from 'render' method is set in
$e-E<gt>response-E<gt> body.

When TEMPLATE is omitted, acquisition is tried from $view->template.
 see L<Egg::View>.

If this VIEW operates as default_view, this method is called from
'_dispatch_action' etc. by Egg.

  $view->output;

=cut
sub output {
	my $view= shift;
	my $tmpl= shift || $view->template || croak q{ I want template. };
	$view->e->response->body( $view->render($tmpl, @_) );
}

=head2 reset

Template ToolKit made once uses as data of the object and is spent.
Please pass render an arbitrary option after it resets it when you want the
object in an option different from former in the scene that recurrently calls
render.

=cut
sub reset {
	$_[0]->{TemplateToolkit}= undef;
}

=head1 SEE ALSO

L<http://www.template-toolkit.org/>,
L<Egg::View>,
L<Egg::Engine>,
L<Egg::Release>,

=head1 AUTHOR

Masatoshi Mizuno, E<lt>lusheE<64>cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007 Bee Flag, Corp. E<lt>L<http://egg.bomcity.com/>E<gt>, All Rights Reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.6 or,
at your option, any later version of Perl 5 you may have available.

=cut

1;
