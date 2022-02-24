// SPDX-License-Identifier: LGPL-3.0-only
pragma solidity ^0.8.6;

import "./interfaces/IWands.sol";
import "./svg/Template.sol";
import "base64-sol/base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract WandConjuror {
  using Strings for uint8;

  constructor() {}

  function generateWandURI(IWands.Wand memory wand)
    external
    view
    returns (string memory)
  {
    return
      string(
        abi.encodePacked(
          "data:application/json;base64,",
          Base64.encode(
            bytes(
              abi.encodePacked(
                '{"name":"',
                "name",
                '", "description":"A unique Wand, designed and built on-chain. 1 of 5000.", "image": "data:image/svg+xml;base64,',
                Base64.encode(bytes(generateSVG(wand))),
                '", "attributes": ',
                "attributes",
                "}"
              )
            )
          )
        )
      );
  }

  function generateSVG(IWands.Wand memory wand)
    internal
    view
    returns (string memory svg)
  {
    return
      Template.render(
        Template.__Input({
          title: "FLOURISHING MISTY WORLD",
          background: Template.Background({bg0: true}),
          planets: [
            Template.Planet({x: -114, y: 370}),
            Template.Planet({x: -225, y: 334}),
            Template.Planet({x: -227, y: 379}),
            Template.Planet({x: 121, y: 295}),
            Template.Planet({x: -19, y: 357}),
            Template.Planet({x: 361, y: 13}),
            Template.Planet({x: 176, y: 259}),
            Template.Planet({x: -156, y: 388})
          ],
          aspects: [
            Template.Aspect({x1: 259, y1: 26, x2: -91, y2: -244}),
            Template.Aspect({x1: 259, y1: 26, x2: -259, y2: -26}),
            Template.Aspect({x1: 83, y1: 247, x2: 84, y2: 246}),
            Template.Aspect({x1: 83, y1: 247, x2: 258, y2: 34}),
            Template.Aspect({x1: 87, y1: 245, x2: 258, y2: 30}),
            Template.Aspect({x1: 248, y1: 77, x2: 191, y2: -177}),
            Template.Aspect({x1: 0, y1: 0, x2: 0, y2: 0}),
            Template.Aspect({x1: 0, y1: 0, x2: 0, y2: 0})
          ],
          starsSeed: 5,
          stone: generateStone(wand),
          halo: Template.Halo({
            rhythm: [
              Template.Rhythm({halo0: true, halo1: false}),
              Template.Rhythm({halo0: false, halo1: true}),
              Template.Rhythm({halo0: true, halo1: false}),
              Template.Rhythm({halo0: false, halo1: true}),
              Template.Rhythm({halo0: true, halo1: false}),
              Template.Rhythm({halo0: false, halo1: true}),
              Template.Rhythm({halo0: true, halo1: false}),
              Template.Rhythm({halo0: false, halo1: true}),
              Template.Rhythm({halo0: true, halo1: false}),
              Template.Rhythm({halo0: false, halo1: true}),
              Template.Rhythm({halo0: true, halo1: false}),
              Template.Rhythm({halo0: false, halo1: true}),
              Template.Rhythm({halo0: true, halo1: false}),
              Template.Rhythm({halo0: false, halo1: true}),
              Template.Rhythm({halo0: true, halo1: false}),
              Template.Rhythm({halo0: false, halo1: true}),
              Template.Rhythm({halo0: true, halo1: false}),
              Template.Rhythm({halo0: false, halo1: true}),
              Template.Rhythm({halo0: true, halo1: false}),
              Template.Rhythm({halo0: false, halo1: true}),
              Template.Rhythm({halo0: true, halo1: false}),
              Template.Rhythm({halo0: false, halo1: true}),
              Template.Rhythm({halo0: true, halo1: false}),
              Template.Rhythm({halo0: false, halo1: true})
            ]
          })
        })
      );
  }

  function generateStone(IWands.Wand memory wand)
    internal
    view
    returns (Template.Stone memory)
  {
    // 24 * 60 * 60 seconds in a day * longitude / max longitude
    uint256 localTimestamp = uint256(
      int256(block.timestamp) + (int256(86400) * wand.longitude) / 32767
    );
    uint256 secondInDay = localTimestamp % 86400; // 866400 seconds per day

    // length of solar year: 365 days 5 hours 48 minutes 46 seconds = 31556926 seconds
    // midwinter is 11 days 8 hours (= 979200 seconds) before the start of the calendar year
    uint256 secondsSinceMidwinter = (localTimestamp - 979200) % 31556926;

    return
      Template.Stone({
        seed: 1,
        color: "crimson",
        seasonsAmplitude: (int256(-wand.latitude) * 260) / 32767, // scale from [-32767,32767] to [-260,260] and switch sign
        secondInYear: secondsSinceMidwinter,
        secondInDay: secondInDay
      });
  }

  // function generateName(
  //     string memory fieldTitle,
  //     string memory hardwareTitle,
  //     string memory frameTitle,
  //     uint24[4] memory colors
  // ) internal view returns (string memory) {
  //     bytes memory frameString = '';
  //     if (bytes(frameTitle).length > 0) {
  //         frameString = abi.encodePacked(frameTitle, ': ');
  //     }
  //     return
  //         string(abi.encodePacked(frameString, hardwareTitle, ' on ', generateColorTitleSnippet(colors), fieldTitle));
  // }

  // function generateAttributesJSON(
  //     IFieldSVGs.FieldData memory fieldData,
  //     IHardwareSVGs.HardwareData memory hardwareData,
  //     IFrameSVGs.FrameData memory frameData,
  //     uint24[4] memory colors
  // ) internal view returns (bytes memory attributesJSON) {
  //     attributesJSON = abi.encodePacked(
  //         '[{"trait_type":"Field", "value":"',
  //         fieldData.title,
  //         '"}, {"trait_type":"Hardware", "value":"',
  //         hardwareData.title,
  //         '"}, {"trait_type":"Status", "value":"Built',
  //         '"}, {"trait_type":"Field Type", "value":"',
  //         getFieldTypeString(fieldData.fieldType),
  //         '"}, {"trait_type":"Hardware Type", "value":"',
  //         getHardwareTypeString(hardwareData.hardwareType),
  //         conditionalFrameAttribute(frameData.title),
  //         colorAttributes(colors)
  //     );
  // }
}
