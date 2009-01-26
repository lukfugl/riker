CREATE TABLE "slots" (
	"day" date,
	"hour" integer,
	"layer" varchar(255),
	"label" varchar(255)
);
CREATE UNIQUE INDEX "slots_primary_key" ON "slots" ("day", "hour", "layer");
CREATE INDEX "slots_without_layer" ON "slots" ("day", "hour");
