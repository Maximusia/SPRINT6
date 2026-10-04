sprint 6 
- Web API:
    - Créer une annotation @ApiController (par exemple)
    déclarer l'interface @ApiController du genre: 

    @Retention(RetentionPolicy.RUNTIME)
    @Target(ElementType.TYPE)
        public @interface ApiController {
        }

    - Créer un controller utilisant l'annotation @ApiRest