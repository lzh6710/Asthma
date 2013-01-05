package Asthma::Spider;
use Moose;

with 'Asthma::UA';
with 'Asthma::File';

has 'urls' => (is => 'rw', isa => 'ArrayRef[Str]', default => sub { [] });
has 'chunk_num' => (is => 'rw', isa => 'Int', default => 0);

sub add_item {
    my $self = shift;
    my $item = shift;

    return unless $item->sku && $item->id && $item->ean;

    push @{$self->{items}}, $item;

    if ( $self->{items} && @{$self->{items}} >= 5000 ) {
    	$self->wf($self->{items});
	my $cn = $self->chunk_num;
	$self->clean_item;
	$self->chunk_num(++$cn);
    }
}

sub clean_item {
    my $self = shift;
    delete $self->{items};
}

__PACKAGE__->meta->make_immutable;

1;
