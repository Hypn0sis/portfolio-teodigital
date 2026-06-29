import os
nome = os.environ["NOME"]
citta = os.environ["CITTA"]
tipo = os.environ["TIPO"]
preview = os.environ.get("PREVIEW_URL", "")

if preview:
    url_section = f"Ho fatto lo stesso per voi, gia online:\n{preview}"
else:
    url_section = "Sto preparando la demo per voi - ve la mando in giornata."

print(f"""Ciao,

cercavo un/una {tipo} a {citta} su Google e {nome} non compariva. Ho provato in tre modi diversi. Niente.

Faccio questo per mestiere: siti per attivita locali che meritano di essere trovate. Il mese scorso ho fatto il sito per una macelleria a Cornaredo - il titolare non aveva mai messo piede online. 300 visite in due settimane, clienti nuovi, zero pubblicita.

{url_section}

Altri lavori: coreflux.studio

Questo mese ho ancora un posto libero. Se vi interessa, scrivetemi entro questa settimana.

Teo
CoreFlux Studio""")
