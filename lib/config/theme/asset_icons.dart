class AssetIcons {
  static const _path = 'assets/icons';

  // Add Font Awesome Icons like this
  static const house = '$_path/House.svg';
  static const circleInfo = '$_path/circle-info.svg';
  static const user = '$_path/User.svg';
  static const location = '$_path/Location.svg';
  static const chevronLeft = '$_path/chevron-left.svg';
  static const chevronRight = '$_path/chevron-right.svg';

// Animal Icons
  static const bison = '$_path/bison.svg';
  static const scottishHighlander = '$_path/scottish_highlander.svg';
  static const wildBoar = '$_path/wild_boar.svg';
  static const wolf = '$_path/wolf.svg';
  static const universal = '$_path/dog_paws.svg';

  // Interaction types
  static const schademelding = '$_path/interaction-types/schademelding.svg';
  static const waarneming = '$_path/interaction-types/waarneming.svg';
  static const wildaanrijding = '$_path/interaction-types/wildaanrijding.svg';

  // Animal species
  static const clovenHoofed = '$_path/animal-species/cloven-hoofed.svg';
  static const rodents = '$_path/animal-species/rodents.svg';
  static const predators = '$_path/animal-species/predators.svg';

  // Numbers
  static const zero = '$_path/numbers/0-solid.svg';
  static const one = '$_path/numbers/1-solid.svg';
  static const two = '$_path/numbers/2-solid.svg';
  static const three = '$_path/numbers/3-solid.svg';
  static const four = '$_path/numbers/4-solid.svg';
  static const five = '$_path/numbers/5-solid.svg';
  static const six = '$_path/numbers/6-solid.svg';
  static const seven = '$_path/numbers/7-solid.svg';
  static const eight = '$_path/numbers/8-solid.svg';
  static const nine = '$_path/numbers/9-solid.svg';

  static String getInteractionIcon(String name) {
    switch (name.toLowerCase()) {
      case 'waarneming':
        return AssetIcons.waarneming;
      case 'schademelding':
        return AssetIcons.schademelding;
      default:
        return AssetIcons.wildaanrijding;
    }
  }

  static String getAnimalSpeciesIcon(String name) {
    switch (name.toLowerCase()) {
      case 'clovenhoofed' || "evenhoevigen":
        return AssetIcons.clovenHoofed;
      case 'rodents' || "knaagdieren":
        return AssetIcons.rodents;
      case 'predators' || 'roofdieren':
        return AssetIcons.predators;
      default:
        return AssetIcons.predators;
    }
  }

  static String getNumberIcon(int number) {
    switch (number) {
      case 0:
        return AssetIcons.zero;
      case 1:
        return AssetIcons.one;
      case 2:
        return AssetIcons.two;
      case 3:
        return AssetIcons.three;
      case 4:
        return AssetIcons.four;
      case 5:
        return AssetIcons.five;
      case 6:
        return AssetIcons.six;
      case 7:
        return AssetIcons.seven;
      case 8:
        return AssetIcons.eight;
      case 9:
        return AssetIcons.nine;
      default:
        return AssetIcons.zero;
    }
  }
}
