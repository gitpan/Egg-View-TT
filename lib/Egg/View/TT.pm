package Egg::View::TT;
#
# Copyright 2006 Bee Flag, Corp. All Rights Reserved.
# Masatoshi Mizuno E<lt>lusheE<64>cpan.orgE<gt>
#
# $Id: TT.pm 247 2007-02-25 10:21:02Z lushe $
#
use strict;
use UNIVERSAL::require;
use base qw/Egg::View/;
use Template;

our $VERSION = '0.05';

sub setup {
	my($class, $e, $conf)= @_;
	$conf->{ABSOLUTE}= 1 unless exists($conf->{ABSOLUTE});
	$conf->{RELATIVE}= 1 unless exists($conf->{RELATIVE});
}
sub output {
	my($view, $e)= splice @_, 0, 2;
	my $tmpl= shift || $view->template_file($e)
	   || Egg::Error->throw('I want template.');
	my $body= $view->render($tmpl, @_);
	$e->response->body($body);
}
sub render {
	my $view= shift;
	my $tmpl= shift || return(undef);
	$view->{TemplateToolkit} ||= do {
		my %options= @_ ? ($_[1] ? @_: %{$_[0]}): ();
		while (my($key, $value)= each %{$view->config}) {
			$options{$key}= $value if defined($value);
		}
		($options{TIMER} && ! $options{CONTEXT}) and do {
			Template::Timer->require;
			$options{CONTEXT}= Template::Timer->new(%options);
		  };
		Template->new(\%options) || Egg::Error->throw( Template->error );
	  };
	my $body;
	my %var = %{$view->params};
	$var{e} = $view->{e};
	$var{s} = $view->{e}->stash;
	$view->{TemplateToolkit}->process($tmpl, \%var, \$body)
	  || Egg::Error->throw( $view->{TemplateToolkit}->error );
	return \$body;
}

1;

__END__

=head1 NAME

Egg::View::TT - Template ToolKit is used for View of Egg.

=head1 SYNOPSIS

This is a setting example.

 VIEW=> [
   [ 'TT'=> {
       INCLUDE_PATH=> [qw( /path/to/root /path/to/comp )],
       TEMPLATE_EXTENSION=> '.tt',
       },
     ],
   ],

Example of code.

 $e->stash->{param1}= "fooooo";
 
 $e->view->param( 'param2'=> 'booooo' );
 
 # Scalar reference is received.
 my $body= $e->view->render( 'template.tt' );
 
   or
 
 # It outputs it later.
 $e->template( 'template.tt' );

Example of template.

 [% INSERT html_header.tt %]
 [% INSERT banner_head.tt %]
 [% INSERT side_menu.tt %]
 
 <h1>[% e.stash('param1') %]</h1>
 
 <h2>[% param2 %]</h2>
 
 <div id="content">
 - Your request passing: [% e.request.path %]<hr>
 - Your IP address: [% e.request.address %]<hr>
 - Test Array:
 [% FOREACH hash IN array %]
  [ [% hash.name %] = [% hash.value %] ],
 [% END %]
 </div>
 [% INSERT html_footer.tt %]

=head1 DESCRIPTION

 e ... It can access the Egg object.
 s ... It can access $e->stash.

=head1 METHODS

=head2 output ([EGG_OBJECT], [TEMPLATE], [TemplateToolKit OPTIONS])

The template is output, and it sets it in $e->response->body.

=head2 render ([TEMPLATE], [TemplateToolKit OPTIONS])

The template is output, and it returns it by the SCALAR reference. 

=head1 SEE ALSO

L<http://www.template-toolkit.org/>,
L<Egg::View>,
L<Egg::Engine>,
L<Egg::Release>,

=head1 AUTHOR

Masatoshi Mizuno, E<lt>lusheE<64>cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 Bee Flag, Corp. E<lt>L<http://egg.bomcity.com/>E<gt>, All Rights Reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.6 or,
at your option, any later version of Perl 5 you may have available.

=cut
