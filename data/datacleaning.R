# Data tomada de: https://www.datos.gov.co/Transporte/Encuesta-de-movilidad-de-Bogot-2015-Caracterizaci-/mvbb-bn7j
require(data.table)
d <- fread("data/encuesta-de-movilidad-de-bogota-2015_viajes.csv")

# Cálculo de tiempo de viaje
cols <- c("dif_hora", "dif_minuto", "dif_segundo")
d[, (cols) := tstrsplit(DIFERENCIA_HORAS, ":", fixed = TRUE)]
d[, (cols) := lapply(.SD, as.numeric), .SDcols = cols]
d[, DIFERENCIA_HORAS := dif_hora + dif_minuto/60 + dif_segundo /3600]
d[, (cols) := NULL]

# Top de los recorridos que tardan más de una hora (municipios)
head(d[DIFERENCIA_HORAS > 1, .N, keyby = .(MUNICIPIO_ORIGEN, MUNICIPIO_DESTINO)][order(-N)], 10)

# Gráfico de las distancias con mayor tiempo de recorrido
require(plotly)
plot_ly(data = d[DIFERENCIA_HORAS > 1], x = ~LATITUD_ORIGEN, y = ~LONGITUD_ORIGEN, type = "scatter")
