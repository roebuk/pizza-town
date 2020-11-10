npm run deploy --prefix ./assets
mix phx.digest
MIX_ENV=prod mix release

rm app.tar
rm static.tar
tar -cf app.tar _build/prod/rel/pizza
tar -cf static.tar priv/static/

scp app.tar root@168.119.157.67:~
scp static.tar root@168.119.157.67:~



# pg_ctlcluster 13 main start
