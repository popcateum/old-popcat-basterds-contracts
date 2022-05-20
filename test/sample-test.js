const { expect } = require("chai");
const { ethers, waffle } = require("hardhat");

//웹 서명 요청이 아니므로 domain은 제외했습니다.
describe("Sign test", function () {
  it("Sign test", async function () {
    const provider = waffle.provider;
    const [signer, c1, c2, c3, c4, validUser, invalidUser] = provider.getWallets();

    //계약 배포
    const OPB = await ethers.getContractFactory("OldPopcatBasterds");
    const opb = await OPB.deploy(
      signer.address,
      "google.com",
      c1.address,
      c2.address,
      c3.address,
      c4.address
    );
    await opb.deployed();
    

    //-- 백엔드 시작 --//

      //서명 메시지 생성 [민터, 팝캣타입, opb 컨트렉 주소]
      let messageHash = ethers.utils.solidityKeccak256(
        ['address', 'uint256', 'address'],
        [validUser.address, '1', opb.address]
      );

      //32 bytes array 를 Uint8 array로 형변환
      let messageHashBinary = await ethers.utils.arrayify(messageHash);

      //정상서명
      let validSignature = await signer.signMessage(messageHashBinary);
      
      //잘못된서명자
      let invalidSignature = await validUser.signMessage(messageHashBinary);

    //-- 백엔드 종료 --//

    //다른 서명자가 서명한 경우
    await expect(opb.connect(validUser).isDataValid('1', messageHashBinary, invalidSignature)).to.be.revertedWith("Invalid signature");

    //정상 서명 + 정상 메시지
    expect(await opb.connect(validUser).isDataValid('1', messageHashBinary, validSignature)).to.be.true;

    //정상 서명 + 정상 메시지이지만 다른 유저가 요청(minx tx)한 경우
    expect(await opb.connect(invalidUser).isDataValid('1', messageHashBinary, validSignature)).to.be.false;
  });
});
