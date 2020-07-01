package;

import tink.tcp.Connection;
import tink.http.clients.*;
import tink.http.containers.*;

import tink.url.Host;
import tink.web.proxy.Remote;

using tink.CoreApi;

interface EgiApi {
	@:get public function player_details( query: { playerHandle: String, vendorCode: String } ) : String;
}

class ServiceApi {
	final egi: Remote<EgiApi>;
	final accsrv: Connection;

	public function new( egi, accsrv ) {
		this.egi = egi;
		this.accsrv = accsrv;
	}

	@:get public function launchService( query: { playerHandle: String, gameId: String } ) {
		return '';
	}
}

class Service {
	public static function main() {
		final egi = new Remote<EgiApi>(new NodeClient(), new RemoteEndpoint(new Host('...', 443)));
		final port = 8080;

		tink.tcp.Connection.tryEstablish({
			host: '127.0.0.1',
			port: 4003,
		}).next(function( accsrv ) {
			final container = new NodeContainer(port);
			final router = new Router<ServiceApi>(new ServiceApi(egi, accsrv));
			container.run(req -> router
				.route(Context.ofRequest(req))
				.recover(OutgoingResponse.reportError)
			);

			return Noise;
		}).handle(function( o ) switch o {
			case Success(cnx):
			case Failure(err):
		});

		trace('listening on :$port');
	}
}
