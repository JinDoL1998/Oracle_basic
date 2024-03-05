-- scott

정규화 : 이상 현상이 발생하지 않도록 하려면, 관련 있는 속성들로만 릴레이션을 구성해야 하는데
        이를 위해 필요한 것이 정규화
함수적 종속성(FFD: Full Functional Dependency) 속성들 간의 관련성
    함수적 종속 ? 
    emp 테이블
    empno(PK) ename     ename(Y)은 empno(X)에 함수적 종속
        X       Y
      결정자   종속자
        X   →   Y
    
    empno -> ename
    empno -> hiredate
    empno -> job
    
    empno -> (ename, job, mgr, hiredate, sal, comm, deptno)
    
    (1) 완전 함수적 종속
        여러개의 속성이 모여서 하나의 기본키(PK)를 이룰 때 == 복합키
        복합키 전체에 어떤 속성이 종속적일 때 "완전 함수적 종속"이라고 한다
        예)
        (고객 ID + 이벤트 번호)  -> 당첨 여부
    
    (2) 부분 함수적 종속(복합키)
        완전 함수 종속이 아니면 "부분 함수적 종속"이라고 한다
        예)
        (고객ID + 이벤트번호)  -> 고객이름 X
                    고객ID    -> 고객이름
    
    (3) 이행 함수적 종속
        Y는 X에 함수적 종속이다.
        결정자     종속자
          X    ->    Y          Y   ->  Z       일때  X -> Z
        empno  ->   deptno    deptno   dname
        
        
정규화(제1정규형 ~ 제5정규형)
https://terms.naver.com/entry.naver?docId=3431248&cid=58430&categoryId=58430&expCategoryId=58430

도메인 : 속성 하나가 가질 수 있는 모든 값의 집합을 해당 속성의 도메인이라 한다.    













        
    
        