init:
	docker-compose stop
	docker-compose rm -f
	docker-compose build
	docker-compose run --rm app bundle
	docker-compose run --rm app yarn
	docker-compose run --rm app ./bin/rake db:create db:migrate
	docker-compose run --rm app ./bin/rake db:seed
	docker-compose up -d
	docker-compose logs -f

migrate_reset:
	docker-compose exec app ./bin/rake db:migrate:reset

db_reset:
	docker-compose exec app ./bin/rake db:migrate:reset
	docker-compose run --rm app ./bin/rake db:seed
	docker-compose restart db

c:
	docker-compose exec app bundle exec rails console

bi:
	docker-compose exec app bundle install