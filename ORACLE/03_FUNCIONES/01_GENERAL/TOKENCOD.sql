CREATE OR REPLACE FUNCTION "&USUARIOBD"."TOKENCOD" (P_DIGITOS IN NUMBER, P_ALFA IN VARCHAR2) RETURN VARCHAR2 IS
  COD VARCHAR2(128);
  V_DIGITOS NUMBER;
  V_ALFA VARCHAR2(10);
  V_DIGITOS_DEF NUMBER;
  V_ALFA_DEF VARCHAR2(10);  
  V_CANT_DIGITOS NUMBER;
  V_CANT_ALFA NUMBER;
BEGIN

  SELECT COUNT(CONFIG_VALOR) INTO V_CANT_DIGITOS FROM GE_TCONFIG 
    WHERE CONFIG_CONFIG = 'Token.Default.longitud';
  IF (V_CANT_DIGITOS>0) THEN
    SELECT CONFIG_VALOR INTO V_DIGITOS_DEF FROM GE_TCONFIG 
    WHERE CONFIG_CONFIG = 'Token.Default.longitud';
  ELSE
    V_DIGITOS_DEF := 6; 
  END IF;
    
  SELECT COUNT(CONFIG_VALOR) INTO V_CANT_ALFA FROM GE_TCONFIG 
    WHERE CONFIG_CONFIG = 'Token.Default.alfanumerico';    
  IF (V_CANT_ALFA>0) THEN
    SELECT CONFIG_VALOR INTO V_ALFA_DEF FROM GE_TCONFIG 
    WHERE CONFIG_CONFIG = 'Token.Default.alfanumerico';
  ELSE
    V_ALFA_DEF := 'FALSE'; 
  END IF;

  V_DIGITOS := NVL(P_DIGITOS,V_DIGITOS_DEF);
  V_ALFA := NVL(P_ALFA,V_ALFA_DEF);

  IF(UPPER(V_ALFA) = 'FALSE') THEN
    SELECT TO_CHAR(ROUND(dbms_random.value(POWER(10,V_DIGITOS-1),POWER(10,V_DIGITOS)-1))) NUM
      INTO COD
      FROM DUAL;
  ELSE
    SELECT dbms_random.string('X', V_DIGITOS) NUM
      INTO COD
      FROM DUAL;
  END IF;
  RETURN COD;
END;
/ 



INSERT INTO "&USUARIOBD"."GE_TCONFIG" (CONFIG_CONFIG, CONFIG_CATEGORIA, CONFIG_DESCRI, CONFIG_TIPO_DATO, CONFIG_VALOR) VALUES ('Token.Default.longitud', 'Usuario', 'Longitud Token Inicio de Sesión por Token', '2', '10');
INSERT INTO "&USUARIOBD"."GE_TCONFIG" (CONFIG_CONFIG, CONFIG_CATEGORIA, CONFIG_DESCRI, CONFIG_TIPO_DATO, CONFIG_VALOR) VALUES ('Token.Default.alfanumerico', 'Usuario', 'True: Alfanumerico False: Numerico', '2', 'false');
commit;