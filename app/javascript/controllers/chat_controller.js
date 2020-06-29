import { Controller } from 'stimulus';
import StimulusReflex from 'stimulus_reflex';
import consumer from '../channels/consumer';

export default class extends Controller {
  connect() {
    StimulusReflex.register(this)
  }

  initialize() {
    // We need to know when there are new messages that have been created by other users
    consumer.subscriptions.create({ channel: "ChatChannel", room: "public_room" }, {
      received: this._cableReceived.bind(this),
    });
  }

  create_message(event) {
    event.preventDefault()
    this.stimulate('Chat#create_message', event.target)
  }

  _cableReceived() {
    this.stimulate('Chat#update_messages')
  }
}
