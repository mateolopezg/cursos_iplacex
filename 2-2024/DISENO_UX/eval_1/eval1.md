# Evaluación N° 1 - Diseño UX

## Actividades

### 1. Informe Completo

#### Portada
- Formato IPLACEX con nombre del proyecto, estudiante y fecha.

#### Índice
- Numeración clara en el pie de página.

#### Introducción
- Breve descripción del proyecto, objetivos y contexto del diseño.

#### Requerimientos de Usabilidad
- **Accesibilidad:** Diseño intuitivo del menú para facilitar la navegación.
- **Eficiencia:** Optimización del flujo de navegación para una orden rápida.
- **Feedback:** Retroalimentación inmediata para confirmar las acciones del usuario.

#### Uso de los Sentidos
- **Visual:** Uso de colores vibrantes y visuales atractivos.
- **Auditivo:** Sonidos suaves para confirmación de acciones.
- **Táctil:** Interfaz táctil sensible y fluida.

#### Modelos Mentales
- **Usuarios:** Adaptación a diferentes niveles de habilidad tecnológica.
- **Dueño del Local:** Gestión simple y efectiva del Panel de Control.

#### Conclusión
- Resumen de los puntos clave abordados.

#### Bibliografía
- Fuentes consultadas listadas adecuadamente.

### 2. Desarrollo de Documentos Manuales

#### Customer Journey Map del Cliente
- Proceso desde la llegada al tótem hasta la recepción del pedido.
- Emociones y satisfacción del cliente en cada etapa.

#### Customer Journey Map del Dueño del Local
- Uso del Panel de Control para gestionar menús y promociones.
- Mejora en la eficiencia operativa y satisfacción del cliente.

#### Mapa de Empatía del Cliente
- **Pain Points:** Filas largas, dificultad para visualizar ofertas.
- **Ganancias:** Compra rápida, claridad en opciones de pago.

#### Mapa de Empatía del Dueño del Local
- **Pain Points:** Complejidad para actualizar contenido del tótem.
- **Ganancias:** Gestión autónoma del menú y promociones.

### 3. Prototipo o Dibujo del Sistema

#### Diagrama de Componentes (C4 Model)

```plantuml
@startuml
!include C4_Context.puml
!include C4_Container.puml
!include C4_Component.puml

Person(customer, "Cliente", "Usuario que interactúa con el tótem")  

System(totem, "Tótem Autoservicio", "Pantalla táctil para selección y pago de productos")
Container(payment, "Sistema de Pago", "Integración de métodos de pago")
Container(kitchen, "Cocina", "Preparación y gestión de pedidos")

Rel(customer, totem, "Selecciona productos")
Rel(totem, payment, "Procesa pagos")
Rel(totem, kitchen, "Envía comanda de preparación")

System(ownerPanel, "Panel de Control", "Interfaz de gestión para el dueño del local")

Rel(ownerPanel, totem, "Actualiza menú y promociones")
@enduml
