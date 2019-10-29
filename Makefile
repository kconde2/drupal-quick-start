build:
	docker-compose up -d --build
up:
	docker-sync start && docker-compose up -d
down:
	docker-sync stop && docker-compose down
logs:
	docker-compose logs -f drupal
