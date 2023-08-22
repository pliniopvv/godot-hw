extends Node

# TUTORIAL SEGUIDO: https://www.youtube.com/watch?v=LEnJGIuRMSk

const IPPADRAO = "127.0.0.1"
const PORTA = 6007
const MAXJOGADORES = 5

var ip = IPPADRAO
var id = 0
var nome_jogador = ""
var par = null
var jogadores = []

signal lista_alterada()

func _ready():
	multiplayer.connected_to_server.connect(self.conectado_ao_servidor)
	multiplayer.connection_failed.connect(self.falha_na_conexao)
	multiplayer.server_disconnected.connect(self.queda_do_servidor)

func conectado_ao_servidor():
	id = multiplayer.multiplayer_peer.get_unique_id()
	rpc("registrar_jogador", id, nome_jogador)
	pass
	
func par_desconectado(id):
	rpc("remover_jogador", id)
	pass

@rpc("any_peer", "call_local")
func remover_jogador(id):
	for i in range(jogadores.size()):
		if jogadores[i][0] == id:
			jogadores.remove_at(i)
			lista_alterada.emit()
			return

func falha_na_conexao():
	par = null
	multiplayer.set_multiplayer_peer(null)
	pass
	
func queda_do_servidor():
	get_tree().quit()
	pass

@rpc("any_peer")
func registrar_jogador(id, nome):
	if multiplayer.is_server():
		for i in range(jogadores.size()):
			rpc_id(id, "registrar_jogador",jogadores[i][0], jogadores[i][1])
		rpc("registrar_jogador",id, nome)
	jogadores.append([id, nome])
	emit_signal("lista_alterada")
 
func criar_servidor():
	par = ENetMultiplayerPeer.new()
	par.create_server(PORTA, MAXJOGADORES)
	multiplayer.set_multiplayer_peer(par)
	par.peer_disconnected.connect(self.par_desconectado)
	id = multiplayer.multiplayer_peer.get_unique_id()
	registrar_jogador(id, nome_jogador)
	pass
	
func entrar_servidor():
	par = ENetMultiplayerPeer.new()
	par.create_client(ip, PORTA)
	multiplayer.set_multiplayer_peer(par)
	pass

func atualizar_nome(nome):
	nome_jogador = nome
	
func atualizar_ip(ip_novo):
	ip = ip_novo

func retornar_jogadores():
	return jogadores
