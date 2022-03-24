SELECT * FROM PLAYER;

/*=============================================================================================*/
# 001. 전체 축구팀 목록을 팀이름 오름차순으로 출력하시오
SELECT TEAM_NAME AS "팀명" FROM TEAM ORDER BY TEAM_NAME;
/*=============================================================================================*/
# 002. 플레이어의 포지션 종류를 나열하시오.
# 단 중복은 제거하고, 포지션이 없으면 빈공간으로 두시오
SELECT DISTINCT POSITION AS "포지션" FROM PLAYER;
/*=============================================================================================*/
# 003. 플레이어의 포지션 종류를 나열하시오.
# 단 중복은 제거하고, 포지션이 없으면 '신입'으로 기재하시오
SELECT DISTINCT REPLACE(POSITION, '', '신입') AS "포지션" FROM PLAYER;
SELECT DISTINCT IFNULL(NULLIF(POSITION,''), '신입') AS "포지션" FROM PLAYER;
SELECT DISTINCT IF (POSITION = '', '신입', POSITION) AS "포지션" FROM PLAYER;


SELECT * FROM PLAYER WHERE POSITION = '';
/*=============================================================================================*/
# 004. 수원팀에서 골키퍼(GK)의 이름을 모두 출력하시오.
# 단 수원팀 ID는 K02 입니다.
SELECT PLAYER_NAME
FROM PLAYER
WHERE TEAM_ID LIKE 'K02' AND POSITION LIKE 'GK';
/*=============================================================================================*/

# 005. 수원팀에서 성이 고씨이고 키가 170 이상인 선수를 출력하시오.
# 단 수원팀 ID는 K02 입니다.
SELECT P.PLAYER_NAME
FROM PLAYER P
WHERE P.TEAM_ID LIKE 'K02'
	AND P.PLAYER_NAME LIKE '고%'
	AND P.HEIGHT >= 170;
/*=============================================================================================*/

# 005-2. 수원팀의 ID는 ?
SELECT T.TEAM_ID
FROM TEAM T
WHERE T.REGION_NAME LIKE '수원';

# 005-3 수원팀에서 성이 고씨이고 키가 170 이상인 선수를 출력하시오.
SELECT P.PLAYER_NAME
FROM PLAYER P
WHERE P.PLAYER_NAME LIKE '고%'
	AND P.HEIGHT >= 170
	AND P.TEAM_ID LIKE (SELECT T.TEAM_ID
								FROM TEAM T
								WHERE T.REGION_NAME LIKE '수원');

/*=============================================================================================*/

-- 문제 1
-- 다음 조건을 만족하는 선수명단을 출력하시오
-- 소속팀이 삼성블루윙즈이거나 
-- 드래곤즈에 소속된 선수들이어야 하고, 
-- 포지션이 미드필더(MF:Midfielder)이어야 한다. 
-- 키는 170 센티미터 이상이고 180 이하여야 한다.


SELECT P.PLAYER_NAME
FROM PLAYER P
WHERE P.HEIGHT BETWEEN 170 AND 180
	AND P.POSITION LIKE 'MF'
	AND P.TEAM_ID IN (SELECT T.TEAM_ID FROM TEAM T WHERE T.TEAM_NAME IN ('삼성블루윙즈', '드래곤즈'));


SELECT P.PLAYER_NAME
FROM (SELECT P.*
		FROM PLAYER P
		WHERE P.TEAM_ID IN(SELECT T.TEAM_ID FROM TEAM T WHERE T.TEAM_NAME IN ('삼성블루윙즈', '드래곤즈'))) P
WHERE P.HEIGHT BETWEEN 170 AND 180
		AND P.POSITION LIKE 'MF';

-- 문제 7
-- 수원을 연고지로 하는 골키퍼는 누구인가?
SELECT P.PLAYER_NAME
FROM (SELECT P.*
		FROM PLAYER P
		WHERE P.TEAM_ID LIKE (SELECT T.TEAM_ID FROM TEAM T WHERE T.REGION_NAME LIKE '수원')) P
WHERE P.POSITION LIKE 'GK';


/*=============================================================================================*/
-- 문제 8
-- 서울팀 선수들 이름, 키, 몸무게 목록으로 출력하시오
-- 키와 몸무게가 없으면 "0" 으로 표시하시오
-- 키와 몸무게는 내림차순으로 정렬하시오

SELECT P.PLAYER_NAME AS "이름", IF (P.HEIGHT = '', 0, P.HEIGHT) AS "키", IF (P.WEIGHT = '', 0, P.WEIGHT) AS "몸무게"
FROM (SELECT P.*
		FROM PLAYER P
		WHERE P.TEAM_ID LIKE (SELECT T.TEAM_ID FROM TEAM T WHERE T.REGION_NAME LIKE '서울')) P 
ORDER BY P.HEIGHT DESC, P.WEIGHT DESC;

/*=============================================================================================*/
-- 문제 9
-- 서울팀 선수들 이름과 포지션과
-- 키(cm표시)와 몸무게(kg표시)와  각 선수의 BMI지수를 출력하시오
-- 단, 키와 몸무게가 없으면 "0" 표시하시오
-- BMI는 "NONE" 으로 표시하시오(as bmi)
-- 최종 결과는 이름내림차순으로 정렬하시오

SELECT P.PLAYER_NAME "이름", 
			P.POSITION "포지션", 
			IF (P.HEIGHT LIKE '', 0, CONCAT(P.HEIGHT,"cm")) "키", 
			IF (P.WEIGHT LIKE '', 0, CONCAT(P.WEIGHT,"kg")) "몸무게", 
			IF (P.HEIGHT LIKE '' OR P.WEIGHT = '', "NONE", ROUND(P.WEIGHT *10000/P.HEIGHT/P.HEIGHT, 2)) "bmi"
FROM (SELECT P.*
		FROM PLAYER P
		WHERE P.TEAM_ID LIKE (SELECT T.TEAM_ID FROM TEAM T WHERE T.REGION_NAME LIKE '서울')) P 
ORDER BY P.PLAYER_NAME DESC;

/*=============================================================================================*/
-- 문제 10
-- STADIUM 에 등록된 운동장 중에서
-- 홈팀이 없는 경기장까지 전부 나오도록
-- 카운트 값은 19
-- 힌트 : LEFT JOIN 사용해야함

SELECT S.STADIUM_ID stadiumId, S.STADIUM_NAME stadiumName
FROM STADIUM S;
SELECT COUNT(*) COUNT
FROM STADIUM S;


SELECT T.TEAM_ID teamId, T.TEAM_NAME teamName
FROM TEAM T;
SELECT COUNT(*) COUNT
FROM TEAM T;

SELECT S.STADIUM_NAME stadiumName, T.TEAM_NAME teamName
FROM STADIUM S JOIN TEAM T
USING (STADIUM_ID);


/*=============================================================================================*/
-- 문제 11
-- 팀과 연고지를 연결해서 출력하시오
-- [팀 명]             [홈구장]
-- 수원[ ]삼성블루윙즈 수원월드컵경기장


-- VER.1
SELECT CONCAT(T.REGION_NAME,' ',T.TEAM_NAME) 팀명, STADIUM_NAME 홈구장
FROM TEAM T JOIN STADIUM S
	USING(STADIUM_ID);
	
-- VER.2
-- 조인보다 스칼라로 때려버리는게 더 빠르다.
SELECT CONCAT(T.REGION_NAME,' ',T.TEAM_NAME) 팀명, (SELECT S.STADIUM_NAME FROM STADIUM S WHERE S.STADIUM_ID LIKE T.STADIUM_ID) 홈구장
FROM TEAM T;
	

/*=============================================================================================*/
-- 문제 12
-- 수원팀(K02) 과 대전팀(K10) 선수들 중
-- 키가 180 이상 183 이하인 선수들
-- 키, 팀명, 사람명 오름차순

-- VER.1
SELECT P.HEIGHT, T.TEAM_NAME, P.PLAYER_NAME
FROM (SELECT P.HEIGHT, P.PLAYER_NAME, P.TEAM_ID 
		FROM PLAYER P 
		WHERE P.TEAM_ID IN(SELECT T.TEAM_ID FROM TEAM T WHERE T.REGION_NAME IN('수원', '대전'))) P 
	JOIN TEAM T
	USING(TEAM_ID)
WHERE P.HEIGHT BETWEEN 180 AND 183
ORDER BY 1, 2, 3;

-- VER.2
SELECT P.HEIGHT,
		(SELECT T.TEAM_NAME FROM TEAM T WHERE T.TEAM_ID LIKE P.TEAM_ID) TEAM_NAME,
		P.PLAYER_NAME
FROM (SELECT P.HEIGHT, P.PLAYER_NAME, P.TEAM_ID 
		FROM PLAYER P 
		WHERE P.TEAM_ID IN(SELECT T.TEAM_ID FROM TEAM T WHERE T.REGION_NAME IN('수원', '대전'))) P 
WHERE P.HEIGHT BETWEEN 180 AND 183
ORDER BY 1, 2, 3;


/*=============================================================================================*/
-- 문제 13
-- 모든 선수들 중 포지션을 배정 받지 못한 선수들의 
-- 팀명과 선수이름 출력 둘다 오름차순

-- VER.1 JOIN
SELECT T.TEAM_NAME, P.PLAYER_NAME
FROM PLAYER P LEFT JOIN TEAM T
	USING(TEAM_ID)
WHERE P.POSITION LIKE ''
ORDER BY T.TEAM_NAME, P.PLAYER_NAME;

-- VER.2 SCALAR
SELECT (SELECT T.TEAM_NAME FROM TEAM T WHERE T.TEAM_ID LIKE P.TEAM_ID) teamName, 
	P.PLAYER_NAME
FROM PLAYER P
WHERE P.POSITION LIKE ''
ORDER BY 1, 2;

/*=============================================================================================*/
-- 문제 14
-- 팀과 스타디움, 스케줄을 조인하여
-- 2012년 3월 17일에 열린 각 경기의
-- 팀이름, 스타디움, 어웨이팀 이름 출력
-- 다중테이블 join 을 찾아서 해결하시오.

SELECT T.TEAM_NAME 홈팀, 
			S.STADIUM_NAME 스타디움, 
			(SELECT T.TEAM_NAME FROM TEAM T WHERE T.TEAM_ID LIKE SC.AWAYTEAM_ID) 어웨이팀
FROM TEAM T JOIN STADIUM S USING(STADIUM_ID)
	JOIN SCHEDULE SC USING(STADIUM_ID)
WHERE SC.SCHE_DATE LIKE "20120317";

/*=============================================================================================*/


SELECT *
FROM (SELECT T.TEAM_ID, T.TEAM_NAME FROM TEAM T JOIN STADIUM S USING(STADIUM_ID)) J
WHERE S.STADIUM_ID LIKE "C04"

(SELECT T.TEAM_ID, T.TEAM_NAME FROM TEAM T JOIN STADIUM S USING(STADIUM_ID)) J



/*=============================================================================================*/
-- 문제 15 
-- 2012년 3월 17일 경기에
-- 포항 스틸러스 소속 골키퍼(GK)
-- 선수, 포지션,팀명 (연고지포함),
-- 스타디움, 경기날짜를 구하시오
-- 연고지와 팀이름은 간격을 띄우시오(수원[]삼성블루윙즈)

SELECT *
FROM TEAM T JOIN STADIUM S USING(STADIUM_ID)
	JOIN SCHEDULE SC USING(STADIUM_ID)
WHERE SC.SCHE_DATE LIKE "20120317";


SELECT N.PLAYER_NAME 선수, 
		N.POSITION 포지션, 
		CONCAT(N.REGION_NAME, ' ', N.TEAM_NAME) 팀명,
		S.STADIUM_NAME 스타디움,
		SC.SCHE_DATE 경기날짜
FROM (SELECT P.PLAYER_NAME, P.POSITION, T.REGION_NAME, T.TEAM_NAME, T.STADIUM_ID FROM PLAYER P JOIN TEAM T USING(TEAM_ID)
		 WHERE P.TEAM_ID LIKE (SELECT T.TEAM_ID FROM TEAM T WHERE T.REGION_NAME LIKE "포항")) N 
		JOIN STADIUM S USING(STADIUM_ID)
		JOIN SCHEDULE SC USING(STADIUM_ID)
WHERE N.POSITION LIKE "GK"
	AND SC.SCHE_DATE LIKE "20120317";

/*=============================================================================================*/
-- 문제 16 
-- 홈팀이 3점이상 차이로 승리한 경기의
-- 경기장 이름, 경기 일정
-- 홈팀 이름과 원정팀 이름을
-- 구하시오
SELECT S.STADIUM_NAME 스타디움, 
			SC.SCHE_DATE 경기일정,
			T.TEAM_NAME 홈팀, 
			(SELECT T.TEAM_NAME FROM TEAM T WHERE T.TEAM_ID LIKE SC.AWAYTEAM_ID) 어웨이팀,
			SC.HOME_SCORE 홈팀점수,
			SC.AWAY_SCORE 어웨이팀점수
FROM TEAM T JOIN STADIUM S USING(STADIUM_ID)
	JOIN SCHEDULE SC USING(STADIUM_ID)
WHERE (SC.HOME_SCORE - SC.AWAY_SCORE >= 3)







/*=============================================================================================*/






