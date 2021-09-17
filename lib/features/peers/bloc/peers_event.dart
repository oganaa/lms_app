part of 'peers_bloc.dart';

abstract class PeersEvent extends Equatable {
  const PeersEvent();
}

class PeerAdd extends PeersEvent {
  final Map<String, dynamic> newPeer;

  const PeerAdd({ this.newPeer});

  @override
  List<Object> get props => [newPeer];
}

class PeerAddConsumer extends PeersEvent {
  final Consumer consumer;
  final String peerId;

  const PeerAddConsumer({ this.consumer,  this.peerId});

  @override
  List<Object> get props => [consumer, peerId];
}

class PeerRemoveConsumer extends PeersEvent {
  final String consumerId;

  const PeerRemoveConsumer({ this.consumerId});

  @override
  List<Object> get props => [consumerId];
}

class PeerRemove extends PeersEvent {
  final String peerId;

  const PeerRemove({ this.peerId});

  @override
  List<Object> get props => [peerId];
}

class PeerPausedConsumer extends PeersEvent {
  final String consumerId;

  const PeerPausedConsumer({ this.consumerId});

  @override
  List<Object> get props => [consumerId];
}

class PeerResumedConsumer extends PeersEvent {
  final String consumerId;

  const PeerResumedConsumer({ this.consumerId});

  @override
  List<Object> get props => [consumerId];
}