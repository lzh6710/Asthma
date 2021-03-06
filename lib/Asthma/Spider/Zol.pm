package Asthma::Spider::Zol;

use Moose;
extends 'Asthma::Spider';

use Asthma::LinkExtractor;
use Asthma::Item;

has 'link_extractor' => (is => 'rw', lazy_build => 1);

sub _build_link_extractor {
    my $self = shift;
    return Asthma::LinkExtractor->new();
}

sub BUILD {
    my $self = shift;
    $self->start_url('http://detail.zol.com.cn/cell_phone_index/subcate57_list_1.html');
}

sub run {
    my $self = shift;
    my $resp = $self->ua->get($self->start_url);
    $self->link_extractor->allow(['cell_phone\/index\d+']);
    my @urls = $self->link_extractor->extract_links($resp);
    
    foreach my $url ( @urls ) {
	my $resp = $self->ua->get($url);
	my $content = $resp->decoded_content;

	my $item = Asthma::Item->new();

	if ( $content =~ m{<h3>([^<]+)} ) {
	    $item->name($1);
	}
	
	$self->add_item($item);
    }
}

__PACKAGE__->meta->make_immutable;

1;
